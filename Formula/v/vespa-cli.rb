class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.685.1.tar.gz"
  sha256 "6c37c6802cf211d3cd34d6f97cdb8c79e73ef1978420053d14a1aed3d39f0622"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de73edfcca804ccfbf37688c575d4eef31b694e5ab63a273dcb8213a51c8dc15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b04f865bc0a2d904552db765c7fe16734c1b1682b6de73b8b5dadbf3c963ea5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73b9a46fc051cf209828e36664f7db3da60d9601e2f08fb288547b24b46590de"
    sha256 cellar: :any_skip_relocation, sonoma:        "29aba8e64d55e9a28367fe77520a41f780d9cf818481a23e4c235ddb0c1dfd11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a376df22ce797804818f73c17a21da2f11e7b10ad7109c828fd21f8d08ba82ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e44f705d3f2b236aa184ce9a31005086ec039f2d2baf68a675bda3d463574ba"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", shell_parameter_format: :cobra)
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
