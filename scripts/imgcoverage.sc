import scala.io.Source
import edu.holycross.shot.cite._

val f = "data/lycimgindex.txt"
val lines = Source.fromFile(f).getLines.toVector
val pairs = lines.map(l => l.split("#"))
val indexedPairs = pairs.filter(_.size == 2)
val indexedTexts = indexedPairs.tail.map(_(1))
val sequencedTexts = indexedTexts.map(s => {
  val urn = CtsUrn(s)
  (s, urn.work.replaceFirst("TL","").toInt)
})
val sortedTexts = sequencedTexts.distinct.sortBy(_._2).map(_._1)

val tlToImgMap = indexedPairs.tail.map(a => a(1) -> a(0)).toMap

val sortedPairs = sortedTexts.map( urn => (urn, tlToImgMap(urn)))



def md(tl: String, img: String, width: Int = 200) : String = {
  val urn = CtsUrn(tl)
  val imgUrn = Cite2Urn(img)
  val label = "*Tituli Lycii* " + urn.work.replaceFirst("TL","")

  val imgLink = s"http://www.homermultitext.org/ict2/?urn=" + img

  val thumb = s"http://www.homermultitext.org/iipsrv?OBJ=IIP,1.0&FIF=/project/homer/pyramidal/deepzoom/lycian/hc/v1/${imgUrn.objectComponent}.tif&WID=${width}&CVT=JPEG"

  s"## ${label}\n  [![thumbie](${thumb})]($imgLink) "
}

import java.io.PrintWriter
val imgWidth = 500
val mdText = sortedPairs.map(pr => md(pr._1, pr._2, imgWidth )).mkString("\n\n")


val hdr = "# *Tituli Lycii*: image browser\n\nImages are linked to zoomable, citable versions\n\n"
new PrintWriter("browseByTL.md"){write(hdr + mdText);close;}
