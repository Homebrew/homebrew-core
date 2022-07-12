class Tfschema < Formula
  desc "Schema inspector for Terraform providers"
  homepage "https://github.com/minamijoyo/tfschema"
  url "https://github.com/minamijoyo/tfschema/archive/v0.7.4.tar.gz"
  sha256 "cfbe9b9ddf84c4a923af4a4fb56e4c4445fbeec244e808b9a365b369cce644d1"
  license "MIT"
  head "https://github.com/minamijoyo/tfschema.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10d59f3a627acdfa33237ddf78e7e7b0cd3a9a97f6a7de79890d835380bb921a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff3333d7e6548454ac126da65a61b30805a2359af1557c8559382d9460f5c27c"
    sha256 cellar: :any_skip_relocation, monterey:       "08f7755ba039a88e324c6499ef59460c839159fa53ab736bcaaa62b257871d1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc4a9205a316f4d71bd144616173d22402d84581f04346f8953a111dbcf754fe"
    sha256 cellar: :any_skip_relocation, catalina:       "18cc3140d396d8629444b20f1a26f35e4eb9df5a44a4ea9127e3178efcd0a5ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2136cc24b73af28cc0e59ee1576208f6dab5f3e5bf48aaceefd544725c5bbd83"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build
  depends_on "terraform" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write "provider \"aws\" {}"
    system Formula["terraform"].bin/"terraform", "init"
    assert_match "permissions_boundary", shell_output("#{bin}/tfschema resource show aws_iam_user")

    assert_match version.to_s, shell_output("#{bin}/tfschema --version")
  end
end
