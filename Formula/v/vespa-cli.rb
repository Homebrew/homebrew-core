class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.492.15.tar.gz"
  sha256 "96741ded78bb45a9852ff266d879cba0b1d51aadddc76dec6db53b99397494fa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73c9b524e9ade9ad3406f491c8a6dd40ff4d5dda9e831d8531aaea1e26b97ba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca5855affbcc4d4a21cd5c266f8d146384c9ba0d714dc40e1e4c7c95eba8866f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e276d9ea9ead4bdbee519ddf1407a9c9b69ead39fd8098dd690be53e2f1ae6e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "acb4e355c7dde290e4cfd5b1e6b6522223c918d0feb3740531c5ea1474d83935"
    sha256 cellar: :any_skip_relocation, ventura:       "8ad39581eaad1023c40f49361ef3549e2582028ded938d5cb53100dcf134ca7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "576d98be9017ecdaa71034db9b5aa80edf2cdaa7c44b45134d180c65e6704201"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
