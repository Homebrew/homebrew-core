class Sipp < Formula
  desc "Traffic generator for the SIP protocol"
  homepage "https://sipp.sourceforge.io/"
  url "https://github.com/SIPp/sipp/releases/download/v3.6.1/sipp-3.6.1.tar.gz"
  sha256 "6a560e83aff982f331ddbcadfb3bd530c5896cd5b757dd6eb682133cc860ecb1"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "334632e3c7eb535151bb272f1dd3b5f8679682ed6930313fc91f51366a2cebe6" => :big_sur
    sha256 "449c55fa3ed88cbbd0ec9f1034d93df5b9affe4e168c7d332fc4a41b4b9f6d0a" => :arm64_big_sur
    sha256 "b5363f025eb4ab69bd4a5d255396115d16ec5740a7de7cc810cffaed2b6e8b7a" => :catalina
    sha256 "43d25e09e529be8802eca6fcc67ea3a9b50927acf71ecc3095a074b8f693afb5" => :mojave
    sha256 "41183e24e41ad9d05017652d0e1ed94e3aeb74883daa165210eafc7f6e034ab7" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "SIPp v#{version}", shell_output("#{bin}/sipp -v", 99)
  end
end
