class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/rrthomas/recode"
  url "https://github.com/rrthomas/recode/releases/download/v3.7.17/recode-3.7.17.tar.gz"
  sha256 "1b0aebe7283b79ff46bc0a06ee21faf65b4d0b304632cbc855721c25583d8ea3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5347c12db883be84b0b18df0895ef8bd1575d0c4a907c02d69c39d0d35fbc994"
    sha256 cellar: :any, arm64_tahoe:       "c4371f38696b416718869824909e9935820d6e7b3008fea921757133ab3e8394"
    sha256 cellar: :any, arm64_sequoia:     "6b7e9e184a490e5118ca6179dabf74239fc1ffb477dbb6eb8032c2cd298a2df5"
    sha256 cellar: :any, arm64_linux:       "10d4082e00cc19ab5a7919f0b964f0c933b1727e47dda5ad08c3f5896736c732"
    sha256 cellar: :any, x86_64_linux:      "d83b3cca77a6c5c7719a2fb6135f74a73f9cbd77404e5162044c85b6f3a6c736"
  end

  uses_from_macos "python" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recode --version")
  end
end
