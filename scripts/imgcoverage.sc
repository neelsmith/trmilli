import scala.io.Source

val f = "data/lycimgindex.txt"
val lines = Source.fromFile(f).getLines.toVector
val pairs = lines.map(l => l.split("#"))
val indexedPairs = pairs.filter(_.size == 2)
val indexedTexts = indexedPairs.tail.map(_(1))
val sequencedTexts = indexedTexts.map(s => (s, s.replaceFirst("urn:cts:trmilli:texts.v1:TL","").toInt))
val sortedTexts = sequencedTexts.sortBy(_._2).map(_._1)
