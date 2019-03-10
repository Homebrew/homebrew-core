class Triangle < Formula
  desc "Convert images to computer generated art using Delaunay triangulation"
  homepage "https://github.com/esimov/triangle"
  url "https://github.com/esimov/triangle/archive/v1.0.3.tar.gz"
  sha256 "0130bdc9d6c6dd35234134dcb97885d48fa22b5c7532767efbe0394497b96fdd"

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
