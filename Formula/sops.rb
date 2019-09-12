class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/3.4.0.tar.gz"
  sha256 "65f680ada424094dcdb80b44e3c11c86235618ef1ab10f5f632fcda954a06363"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "65df7ca6d13386edc9c99f3c95c2e7b18cf586fcd228f6644f974c5ca508b52e" => :mojave
    sha256 "a465ee3a048e1ef83497325dc76370d96404f6789178a4efbd19215630fd58dd" => :high_sierra
    sha256 "8345f9f6375d27756ad9a8b6adab4c249bdc223b863e20258f869da79f90ea69" => :sierra
  end

  depends_on "go@1.12" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    dir = buildpath/"src/github.com/mozilla/sops"
    dir.install buildpath.children

    cd dir do
      system "make", "install"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version 2>&1")
  end
end
