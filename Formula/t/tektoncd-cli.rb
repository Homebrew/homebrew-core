class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "c1b90ba3d4830b2ee6c039d32e336378da1f0a5d14100655ed22953d483c2098"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ced03fd56defd8104ca6ea49e8cf1614d6b093fdb20051b5dfaf1a711ab0dfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83b8a76f775e8a3a0e21566dcb5596c15cf77a2cbeaa18081327f2085891dd2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fdd450213d5bf04fb18bab3f5465295de588d943dc374d72eeb043835a6b758"
    sha256 cellar: :any_skip_relocation, sonoma:        "11007e6d79e38eedf78e036e92afd06c1999915d101ac1ebbc6587e8a71ad303"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a31dbf910228523c8d2238bd98256883e9ac9fb377dc1b59a76c569fe5f22076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc68cb56e03b5fc5052dd3bfaf89d681bd418677ca564575b8bbfb2dd1ca92a8"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/tkn pipelinerun describe homebrew-formula 2>&1", 1)
    assert_match "Error: Couldn't get kubeConfiguration namespace", output
  end
end
