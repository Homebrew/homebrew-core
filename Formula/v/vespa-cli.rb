class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.320.68.tar.gz"
  sha256 "10b294573d9c412bbef764e5b1de9f1d2246e4ee05aa71fff251f78779977862"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afd013960fcd21e03f2c8e4020bfe6893a710bd807c074c67b179f72c183fce0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59602112492f30a8722efb21d9d3eaafba1c691bb2622040c73c8f21f5c134b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb835dc6859e180c258c9e58dde31560808639fb22c79cdb9ae9b24f3717fb70"
    sha256 cellar: :any_skip_relocation, sonoma:         "0beef24e2695ef61fe60904f84e856cb1b82f5c08268cec3f2cd12a73707b59b"
    sha256 cellar: :any_skip_relocation, ventura:        "40a5783bd46e01a1aba765dde648bf1f1c97f2e8635e4f6461493ee15f0a8983"
    sha256 cellar: :any_skip_relocation, monterey:       "9e0aa37ba4c0b08341261280bf43f8af3a44e0d22982951391597654ebc276ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "654f7397c8df827f8d16a7761ba031257917508c53d9afa6f2405b44f8b55731"
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
