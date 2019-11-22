class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/v3.5.0.tar.gz"
  sha256 "a9c257dc5ddaab736dce08b8c5b1f00e6ca1e3171909b6d7385689044ebe759b"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "184c2b79a276faa3efb6ec26c8ebb98d1e24b0cdd8bade41136943d787d6ee9c" => :catalina
    sha256 "ab29594d5eb30f6470adb2c9937b9288f024a233d961dbbb965e03f58355dff6" => :mojave
    sha256 "3f4baab5e9e5e53bec5f76eb1c7786db53c6e83f6dce1c20aabbd5bb180f486f" => :high_sierra
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
