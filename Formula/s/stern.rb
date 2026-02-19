class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "24101b69a65e5fcfa459806c9628540c8085e8427fb44a28b6daf8c865215878"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af35aecefbd4c2b1be1e461142d3564e5b99560c4d219e3341298d2c7f0c33cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b6dc5128e378f0c30fb217ca3942ac5a417500ab44f3afcb0d866b8312abf55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9400bab425c16eb532dfe42f78d7b031a83585a5b0e581266776a1f30593339"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4f18fd2df16ec8934441ca211882cbb6a0786df1382f2bf19aa60ce7698d14f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09a7ad11ceae2bd689efa18a06031b9256cc2cce00906f12d97d3aafc71fb3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ae5e78ab281417f4028b95007dac56edcd8ad20b630a9086529de253ab81671"
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
