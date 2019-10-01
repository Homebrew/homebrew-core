class Screenresolution < Formula
  desc "Get, set, and list display resolution"
  homepage "https://github.com/jhford/screenresolution"
  url "https://github.com/jhford/screenresolution/archive/v1.6.tar.gz"
  sha256 "d3761663eaf585b014391a30a77c9494a6404e78e8a4863383e12c59b0f539eb"
  head "https://github.com/jhford/screenresolution.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "53636977689925be4ef97933dc0f1b411f0cd82f71a268cfe7c6f90d5a294f97" => :catalina
    sha256 "15d61e87178dbe8ef88c9cb75251f472efc42830b1a2c5be25e4a5bd074e0c66" => :mojave
    sha256 "b2f7b0933c734d5ecd8bfafae8d384f20821c45ca38fc81308035d3ca79f3535" => :high_sierra
    sha256 "ef630f5af67d6bcdde3fd580917ad05d871274f0d62b2a76705ab2b9683f334f" => :sierra
    sha256 "63cfb53fe13d5f5b2c72e8a644b312f8a144b12e2b3f284de5adfc5010e1570d" => :el_capitan
    sha256 "3b3f5d4c414aa36ee1ce963d47a82a50e06f1ffc7a36759bf13ee12c43845c73" => :yosemite
    sha256 "9e6944af938c0c9ec9e1e4a79a6849fabb222baa0d977a9425bee6a2827595d0" => :mavericks
  end

  def install
    system "make", "CC=#{ENV.cc}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/screenresolution", "get"
  end
end
