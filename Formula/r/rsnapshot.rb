class Rsnapshot < Formula
  desc "File system snapshot utility (based on rsync)"
  homepage "https://www.rsnapshot.org/"
  url "https://github.com/rsnapshot/rsnapshot/releases/download/1.5.1/rsnapshot-1.5.1.tar.gz"
  sha256 "8f6af8046ee6b0293b26389d08cb6950c7f7ddfffc1f74eefcb087bd49d44f62"
  license "GPL-2.0-or-later"
  head "https://github.com/rsnapshot/rsnapshot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6404aabe4e16911cc94cc72f61b06e05cb1837c21ab04294d0916c109b068de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39b58196928c11b7de3c7dd9672da95b53d5df2c03191b9a7d6aafb869b02a95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39b58196928c11b7de3c7dd9672da95b53d5df2c03191b9a7d6aafb869b02a95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a674cc867fa495164b1d4d9c09b3f88f0e02d918c593f3a5a63969612bdd0a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e46b5d9473dd7afd78d62ce1113a3b7b165e3e15ee43ee2993b06bd1dd89956c"
    sha256 cellar: :any_skip_relocation, ventura:       "681fd3a9e4c2276dcbecc2a22e721cf31efadd6ed786beae3efc127f8b488ec0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c3384d109f947065a499e2980c0d982a38a94bae93072bdd04540133ea774b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a02d7163670d6f9a5086e0c50c3ba6b5442639d961a630773a9f1d001a211cbc"
  end

  uses_from_macos "rsync" => :build

  def install
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rsnapshot", "--version"
  end
end
