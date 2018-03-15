class Sops < Formula
  include Language::Python::Virtualenv

  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/3.0.2.tar.gz"
  sha256 "c370664e8d9892ea7a5cdde371b3a5e83df7b546b1b0ec0c8d549a109365312d"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be0cafec895e9c3f83c5c19288f0f0756584f16714085457a7bcc98f57bf0784" => :high_sierra
    sha256 "3780adcbcfca03b010f5b9ada6af894142670be95aa0dcbc58e830a943c7b8dc" => :sierra
    sha256 "b9a5ad6aacb684964c7f89ae3e7e1921f2b89e9115ea55720a36da3ef40ddb73" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/go.mozilla.org").mkpath
    ln_s buildpath, "src/go.mozilla.org/sops"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version 2>&1")
  end
end
