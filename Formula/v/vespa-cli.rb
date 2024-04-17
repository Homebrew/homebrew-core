class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.329.17.tar.gz"
  sha256 "457a77393604047b7c34fb8ed57d9d73210abe7a401c20fbb3a0286bf2d49e04"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b05ca1834292b53505a64a7827384389989e4de2da8ba18c7823f409dcd3b2ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "727581ae1743144b2938c5fd5a2dcd6a0ab64dab1a53c71f27e7245ab2b77e23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f5f708936ba12c3676ed3212b00c0519576c0548c4e121b29f5fbd7c620487b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a9b24ff4f9af6bbfa3e5ae19c5b8c63879256550567cba7274487e2165b2147"
    sha256 cellar: :any_skip_relocation, ventura:        "3a6d4febeefcced0e27cb78ab8bd687abb56221b13eca5a24de2bb904e1683db"
    sha256 cellar: :any_skip_relocation, monterey:       "0d1c9fbcc4894b88e17e87310ecb4187b42e62c5f834fb1ae51105305fd5c737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ff3e68b700734e479396e961cfded636e90f3970b3b76deb6de90798976b844"
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
