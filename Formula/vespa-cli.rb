class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.101.28.tar.gz"
  sha256 "42fed6ac42c95924436fe8c24a9f390757dbaa606740b80841af6a3df959d710"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2f8966f4c097e0947a41276a20f3258b3bfb4460b0a4a3dc75980360ce8db54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75684a0d3ec7aab1f987a4d825495c7adbe4537f4460df8d36c859fea0781d62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6494f839cadedbe8646e1c462bf1568ec40248973d7155de1906594884957670"
    sha256 cellar: :any_skip_relocation, ventura:        "65171358bfc078ec77149db286a98fc673fe737e163a9f2ecd25d2417fadbdee"
    sha256 cellar: :any_skip_relocation, monterey:       "a43b25bcd3815c92e03fae0e63056fa423d414c0ac07d6cc7d787aac71d10e48"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb9251f6740239759a16708fd22a93c0dc5c57a659a7725ff42970f222c0e2df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcc7e0443371550ad873aa196775f8a7f20f6dccff4152d7caf780731b48afbb"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s) do
        system "make", "all", "manpages"
      end
      bin.install "bin/vespa"
      man1.install Dir["share/man/man1/vespa*.1"]
      generate_completions_from_executable(bin/"vespa", "completion", base_name: "vespa")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
