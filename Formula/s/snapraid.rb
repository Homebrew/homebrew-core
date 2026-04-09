class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v14.1/snapraid-14.1.tar.gz"
  sha256 "b33e19558ad0f29f1c8d3907a772377f1125f19b44003db8b8df05cec46cd7c6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae244c68599c9f836cd7ead50b72aac6bc1ff693c17c78c10884deae913bf424"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "823465ce79d61c2d1f3094e7ec468b75bb0adcb062678d71e4a371d8d93d2821"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3e3f24ffa52fa6769f13ab164bcca08eb93603544f50331e48aee74181cdc25"
    sha256 cellar: :any_skip_relocation, sonoma:        "66ea8f86e7d6001e4c4afa93c366792c7adcb440c837d841330835f17568c605"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dca5fa97366e905beecfb1c0eb9c83a760bd7733419caefce4cf89d5eea34fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16ff37466314bb669f4b8c9950fabfce60bd39d4303e44d42712fa091d94d555"
  end

  head do
    url "https://github.com/amadvance/snapraid.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
