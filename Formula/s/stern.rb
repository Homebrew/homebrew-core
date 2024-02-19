class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "7d0914cc3a3b884cce5bcbeb439f5c651c72f0737ba9517b663d7f911804489e"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a5619f1653a6181ccbdcc4ee5c32db8a17c972ff67747cf7f2a48b1475af8c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61355e42bdb24d895f26690a6db217c91fa1daad1b24ae0ceb0c726cec65307f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7137a8ea403539f43a2fa17104af29292030ee927a73a2790b92077aab3e8f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3bc931627d8c8523b00793a3d4ccd87175ee2ce5ab0a930e7fc1a072f2952ed"
    sha256 cellar: :any_skip_relocation, ventura:        "da271ef0adb308161ffff285aaf1b48392a2c074bef6f60b3c1af0acd1a8155d"
    sha256 cellar: :any_skip_relocation, monterey:       "008aa981a8559b0b4bac5cf1bb11cfc373af5d175915e2a4da7ec9f7b5447323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9131cc6366cf57f0cd22a296e1182590ec516cecb4d8430617f2be52d7d36154"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    generate_completions_from_executable(bin/"stern", "--completion")
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
