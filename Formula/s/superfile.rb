class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://github.com/MHNightCat/superfile"
  url "https://github.com/MHNightCat/superfile/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "bb46ccc7994f91013a8d0fb5809b832ec1982a55fbcf704aaa5eed6e211f2635"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d40c01ddcbc05f08d9d9592bc491262e362ba9535419c8d515ae2caf8b075404"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d74fff4e25d4ef09995c93b314664b57ce6141012ba7b92fbc1c65e9bb004a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b147aeea02d427b85c3f00ab462280a7242afb4ef4b5db68feef80b7b23b7654"
    sha256 cellar: :any_skip_relocation, sonoma:         "271ee4bf586de47309e2bd1cc5b66b0e575bc15aad179e33ff844a9993812a0e"
    sha256 cellar: :any_skip_relocation, ventura:        "f7ba8b0c4a91eb1edc8d70befb3bfc1cb91741d4765c2fcb7c35124612f99f1a"
    sha256 cellar: :any_skip_relocation, monterey:       "2310bccada7ab35c534de03ba37f9adb566a20ae9cc9b65aa55a7de6d5fefe37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f49fd3575d6e6f3cfa71c37daae3c9c041ee28fe73399183606a11af3b701ba"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"spf")
    end
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}/spf -v")
  end
end
