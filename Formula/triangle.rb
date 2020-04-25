class Triangle < Formula
  desc "Convert images to computer generated art using Delaunay triangulation"
  homepage "https://github.com/esimov/triangle"
  url "https://github.com/esimov/triangle/archive/v1.1.1.tar.gz"
  sha256 "e62b05cf654ee9c61b8145aaea32f54ee39da872cca37084c96db5cda6587ad1"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fb744b3878eb0a3b661b939155929dd3e24050b6bdf79a21926309b9e37c030" => :catalina
    sha256 "e9028dc0560174e50099fdb6efc3dcbb8ed75a8cfc983e2b923a18f54acb1807" => :mojave
    sha256 "aca7f95503e929a3bc8b585e64177dec4d8625bd3d365b18d8fecc8fa463a859" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    dir = buildpath/"src/github.com/esimov/triangle"

    dir.install buildpath.children

    cd dir/"cmd/triangle" do
      system "go", "install"
    end
  end

  test do
    system "#{bin}/triangle", "-in", test_fixtures("test.png"), "-out", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
