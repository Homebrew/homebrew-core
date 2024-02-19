class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.302.40.tar.gz"
  sha256 "880a83d03b4f9ef2450d370d8af443614f9a556ab67d20985edf81fe786a6da5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a70989ec75bc27f0848ee6d5db527fee82de21a824f38b791e0a835c817d4e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f70951b3ad7521b96a36b2eda8bc51012dc6bac7d0c85d65d891a24218f7cdf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac663133c6155b9eb626d281361fb60e6b9ea2ab6f6d6d57e81abcf4717418dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dde3e9701ff94374d0d455dc84b6d3ed20c0c0d28a81d864954464fc9aa5d90"
    sha256 cellar: :any_skip_relocation, ventura:        "14015e68c97fe7d8738c4a57c1014db3f41e208dcc2bbc1f0d98a8ac1f9c0990"
    sha256 cellar: :any_skip_relocation, monterey:       "c760b1f3d9647b13197649bccad3570891363313af30151b028cadcf13456054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48ae250c0f9d4884a26380ee0adab9aec88aad15260f03950d7eabe22d40d391"
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
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
