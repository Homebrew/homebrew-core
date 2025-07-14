class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://github.com/symfony-cli/symfony-cli"
  url "https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.12.0.tar.gz"
  sha256 "327f8cc77e3ddec57a560520521a2da5aeee1dc8b9a45d53ac2e60487b0fba48"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdb9ec2212e40862422cca0ecebe09167f2e811db21119ee3870cde307930838"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f90063aa42eb21007d68085fa7d6206179557715c578562c785bec14a5fdb7fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af855856b78bac4b2668a840dad168de51316dafd90eaea722e402c196c549ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "94880b4c05a6bb84f82acd36e1a855cc3b6aecd48ccc0688406f4669dfd62bec"
    sha256 cellar: :any_skip_relocation, ventura:       "8121c2ecfc21c484cc33edd21705da4429d970cb515e84fd87ca2f39dbda3148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e99423e8a0ad1207bdec43b1102ba926ac5a4e1e08b62801ee72a45c35a8482"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.channel=stable", output: bin/"symfony")
  end

  test do
    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
    output = shell_output("#{bin}/symfony -V")
    assert_match version.to_s, output
    assert_match "stable", output
  end
end
