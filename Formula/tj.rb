class Tj < Formula
  desc "Line timestamping tool"
  homepage "https://github.com/sgreben/tj"
  url "https://github.com/sgreben/tj/archive/7.0.0.tar.gz"
  sha256 "6f9f988a05f9089d2a96edd046d673392d6fac2ea74ff0999b2f0428e9f72f7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab9e94d37b842d4d96e8a1ce0e6a87b7d5f333467662bf311f4a23a6a05d3088" => :catalina
    sha256 "9e9789735a9437803ccadf92845d8bfb2f85e11429fb97e195c01fb2887cf045" => :mojave
    sha256 "6e47b0d410b1a9aafc4b31bf6f397e5b6194faf2aea88e0fc0f45a4584adbf37" => :high_sierra
    sha256 "f62d1e6bebec485f947355a7a0a79fd9f3986396ac5f79c96e630693533a5c9d" => :sierra
    sha256 "679f41ee55f109604f19583683f43406e4af88f86b60534ab4e758d5b2192940" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/sgreben/tj").install buildpath.children
    cd "src/github.com/sgreben/tj" do
      system "make", "binaries/osx_x86_64/tj"
      bin.install "binaries/osx_x86_64/tj"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"tj", "test"
  end
end
