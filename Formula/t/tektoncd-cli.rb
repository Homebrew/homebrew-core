class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "6e52a891bada3ff6351f5da49b1c67eca93b9f2d71669194ef52da4be7dd8c45"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74962f47a93b8edd0d4e180ec4195ca2614a2fd8404da6b388dcb38af4dd4b81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ccb71f0f7d45eb3ef3500ad16dd77707008e166a2adbfeba2958d50c09b7d26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe19aa6c483fdfd461f47823030ef40bdd90c01dba532817d52052952d70a0fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "26994aca13238c91a19cf531ba6fd35f30bf5aef6ef8b96ea48bec56b964c97c"
    sha256 cellar: :any_skip_relocation, ventura:       "1435284fb9c6cafa4ce6427278d096ecc689bbcb939b2b9c241cf6db38041e62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83d87c9c5865d34cee73fca59c25d21e99878b008b3cff6e0bd749e3c9346c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f935637469ec992a6eedc73b55c0f878146ea9ea2c6bcca742bc15b14a209fd1"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", "completion")
  end

  test do
    output = shell_output("#{bin}/tkn pipelinerun describe homebrew-formula 2>&1", 1)
    assert_match "Error: Couldn't get kubeConfiguration namespace", output
  end
end
