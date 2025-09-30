class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://github.com/symfony-cli/symfony-cli"
  url "https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.14.2.tar.gz"
  sha256 "7347c365f04572807a358f0171859d90f66194bdeb28c09e955d27415dca6f5a"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8308d5a3901faa2b82cbc6db3ef18c00da9a0f33f971729b53e96789f923fdfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4c1b25958808a73f9fb822fa2af89c05db378ef4f4a91d554e83e7ae6a1836e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec36ecb1e4f8a7e5c23e92556c91c5f344ba28f2c862243dff0ec264f38767a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "132f9106f2c3e948e62a18f568a919d139ff32db09399e98c575e5ef351746dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43210637af64bc1d64eda0e049606f43c68c60a938e4ca9c5f479339b0545b27"
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
