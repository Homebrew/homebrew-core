class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/rrthomas/recode"
  url "https://github.com/rrthomas/recode/releases/download/v3.7.14/recode-3.7.14.tar.gz"
  sha256 "786aafd544851a2b13b0a377eac1500f820ce62615ccc2e630b501e7743b9f33"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e5b555025428589a5e93a28f94351a958ead8e9a0bcd5dc7beedf96e700a99c0"
    sha256 cellar: :any,                 arm64_ventura:  "43e1f1c1e34ea2a6ce0e794aa99378dcc282b88e75abd5b64407544f79b18f5e"
    sha256 cellar: :any,                 arm64_monterey: "a350ff1d98007511a123cc29e8d338164d36ad97126e1cbf6f706d70d4a55238"
    sha256 cellar: :any,                 arm64_big_sur:  "30c322a156a08ef567279ebafbe6766be1d65306e1ed0529554effd1ec682167"
    sha256 cellar: :any,                 sonoma:         "958e4b07518d05168a61afd21409847e7c9b4283addcf2ef3cd2b454b7e63c64"
    sha256 cellar: :any,                 ventura:        "e994c456daa78b8e6c324ca5802b6b6ebf27207585280430102090299841ba1b"
    sha256 cellar: :any,                 monterey:       "37660b18533ce9c469a27dce18f577947f4f5a7dbbb26b19e50a88d9ee9e2eb7"
    sha256 cellar: :any,                 big_sur:        "249ce4061a2202c4a0435c913e34856a5f91ffe761a31a1ce43a55509dc19599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebf5fa37f30212152b21e78386294f7c25217ab049414d840bcbc87738bfe110"
  end

  depends_on "help2man" => :build
  depends_on "libtool" => :build
  depends_on "gettext"

  uses_from_macos "python" => :build

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recode --version")
  end
end
