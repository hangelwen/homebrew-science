require "formula"

class MirPrefer < Formula
  homepage "https://github.com/hangelwen/miR-PREFeR"
  head "https://github.com/hangelwen/miR-PREFeR.git"
  url "https://github.com/hangelwen/miR-PREFeR/archive/v0.21.tar.gz"
  sha1 "46f64d1ee01715cdd0215c2cd05997fbc59f0261"

  depends_on "samtools"
  depends_on "viennarna"

  def install
    prefix.install Dir["*"]
    bin.install_symlink "../miR_PREFeR.py"
  end

  test do
    system "python #{bin}/miR_PREFeR.py -h"
  end
end
