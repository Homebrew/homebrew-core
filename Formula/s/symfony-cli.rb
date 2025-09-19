class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://github.com/symfony-cli/symfony-cli"
  url "https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.13.0.tar.gz"
  sha256 "e21afada41ba7d5149ce55133f760100f8e875aec837855acef2968e8712248d"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed819083eab782305b9c6de2313c66816c4f140bbe02ac5f0864196131b40429"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "887277e92ed2366b422a6f2392b4fa0cc3a10637f946056ad87f99a5d3f7d476"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb63440d3c549907d190df004f6415144b52d5740da4d06d3b1b08e69299a776"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ebc75121ac96e37ce0e564d5155cffc515c1e85ecb80d220f1aa7079c5125a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5308570206bf19f80bc13bee7c11153f3a41a0cb3e1412d13fc2ba6316a9bd2"
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
