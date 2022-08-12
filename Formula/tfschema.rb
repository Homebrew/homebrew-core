class Tfschema < Formula
  desc "Schema inspector for Terraform providers"
  homepage "https://github.com/minamijoyo/tfschema"
  url "https://github.com/minamijoyo/tfschema/archive/v0.7.5.tar.gz"
  sha256 "0642b125805e812675f542feb5f2ab54bdf5660c12c93f86e90469407b204a04"
  license "MIT"
  head "https://github.com/minamijoyo/tfschema.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34bc7541423b20c907504005dd7cacead7e28700f96ecb75ed94eebdad9e1fb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6676c102aa7391dd1f512a64ab64a8b8ddc190aa5ebfd0ef0be480a86cd8488"
    sha256 cellar: :any_skip_relocation, monterey:       "6185117edc1c8c4e26525dc6af6783a2790dc0dab12e750334d44a4981a9e174"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cfa21e5b07ca35458512c8290b756c5fe4631b26d9329648efd45d40c2b8121"
    sha256 cellar: :any_skip_relocation, catalina:       "f680e7861c2bd8795722597e7cb252eb2c202cddbadca1c5e4775413d696fb39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e100da387b08ad06a1ebddf5f5fd6d3bad35bdfab7155e14f45c2e3cce557a5d"
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
