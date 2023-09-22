class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.229.1.tar.gz"
  sha256 "184d5dc6c1b656042ec24f859a79fe9e6ba0e6ca61608d05647950ccab729bbd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8f1efcb0d0120a4896d1ae573461fafd43dcad100686b0dfd465730afb3f90d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dee276b08e8f623c513ca6dd18f934e4fcdb260be32530f99c2e9dd55194616"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4df2128aa381a6101ab8e5ab3a81ab061804d18f10766e8158c2e7b08613854"
    sha256 cellar: :any_skip_relocation, ventura:        "ac67ee9f9a7a06b567e2a13824a6eb0894861062a932915d4869735d2de2b2af"
    sha256 cellar: :any_skip_relocation, monterey:       "15ec9cf15e815c24af069e5915d21b77470673923267f00cfd45f084d15b3405"
    sha256 cellar: :any_skip_relocation, big_sur:        "37a9ae03a09c7fd30e733bd69700d61a27123e31091bb5c9e4d7ef77f8e2b997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81beeaf04e5019f51ab96b42ca4c9cf6b7b87457b33446fce3133bf807b810b9"
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
