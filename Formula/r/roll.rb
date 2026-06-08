class Roll < Formula
  desc "CLI program for rolling a dice sequence"
  homepage "https://matteocorti.github.io/roll/"
  url "https://github.com/matteocorti/roll/releases/download/v2.7.0/roll-2.7.0.tar.gz"
  sha256 "9e116501aaa0c8f954d31a86e8cf6dee5d98ee35a5e8e5b025646c4bee741533"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7b7d5f5d981510645495a608c12615909ffa3b9b3fc6ba5e9faf5fdacb6c510"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9a9d4588c91eb0325b8601960a763f76232ecb28c866ef5b87050b7f3bbb72b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7d2ac3789b181f01e5e4cd5bd914df40dcbb43f133be87a7320a445011ba5c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cc13149f0571a32c72e58ff8bd306a4bc1c0401ec6e4cf084ab6d198178ffde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caa11bc9eac9982f9e6a17ac7e28af140533f97e84faff5022e5757829682e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc292cc25912ad6b5282b6f12d418b5a097cabb71fe41f098bc03243ed9eadad"
  end

  head do
    url "https://github.com/matteocorti/roll.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  on_macos do
    depends_on "pkgconf" => :build
  end

  def install
    system "./regen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"roll", "1d6"
  end
end
