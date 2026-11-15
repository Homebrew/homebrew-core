class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/refs/tags/v26.10.119.tar.gz"
  sha256 "211c99ab4e077c5ba3d3fc43e095c31a2f0706bdde26664b2981095d01296a39"
  license "MIT"
  head "https://github.com/roswell/roswell.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "891d1e1bd58d41e95e0e172f4f043e61eb4b6b7e6236b0cad40a2bb903c25726"
    sha256 arm64_tahoe:       "760e161842a5126a2ea13180a472f5d6001c072865ea4c58292859d30a911945"
    sha256 arm64_sequoia:     "70d8877fa10b4e06ae24b4299f97dd84e8b03481c69eb3180e29d825615b1153"
    sha256 arm64_linux:       "4a9da299112fba5848d3809af70cecd2275e4a39979e5e822be80257fb352be3"
    sha256 x86_64_linux:      "ea2d27a44280f039b3a80ee62d36fd94083311b5f2735faed0b391a4602723da"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "curl"

  allow_network_access! :test

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_path_exists testpath/"config"
  end
end
