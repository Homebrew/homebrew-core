class Tfschema < Formula
  desc "Schema inspector for Terraform providers"
  homepage "https://github.com/minamijoyo/tfschema"
  url "https://github.com/minamijoyo/tfschema/archive/v0.7.5.tar.gz"
  sha256 "0642b125805e812675f542feb5f2ab54bdf5660c12c93f86e90469407b204a04"
  license "MIT"
  head "https://github.com/minamijoyo/tfschema.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3f7e711f325ee58dda16f45d13187884c1b04f8e80d1c1d5fd3afbfb5105601"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b337919ffdcc2450e142cedfe51dfdd0ab91c5c97f451d047d024556430fe966"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a894518428d7803bb0d18617bed08805195eb02e7b56632c6202d730378c51aa"
    sha256 cellar: :any_skip_relocation, ventura:        "17bed45c783f855c0ad44ae4c08319301ce56f1bbfaba05425bc4c9a6eb70f1f"
    sha256 cellar: :any_skip_relocation, monterey:       "a5945fcd8872038b39d1315cfef5c803cabcd2c9189db0909fe55f484566568d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb2c432065da78390f6902797fd439ecf645f20f12aa6a7302382f6e2e5b8def"
    sha256 cellar: :any_skip_relocation, catalina:       "a69cfd013aaf2f42bda4e899fe427a36a4f552afcaf86ce13da04d53024d5056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2215c0ed4688650a185e0dd4342ca5b89c6238a6ae46531a404dcdb2705a6fc"
  end

  depends_on "go" => :build
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
