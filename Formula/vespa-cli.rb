class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.108.22.tar.gz"
  sha256 "3ec1458de8f42059f4a281555c1d78537ad23a2bf7fcb418a41b9e498d80a3cb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ff3bc265b1101e511bc4e7ebf140edd7723ffebddb064d77d7ca8e3bd56a220"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "310962eb56af8a84531bcd15a9110b752e19f6bce06af5f815325b2551324695"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcdf5880174548834df7ca3d27b5a251be87f4718557ca46785490b30c656e93"
    sha256 cellar: :any_skip_relocation, ventura:        "448c467dc377948840633de542812e956af5a8532106b089cdeecae3bc67333e"
    sha256 cellar: :any_skip_relocation, monterey:       "98c11a3bae4d9542a20cfc97f347cd9727f6f9a033177626ae693bb31c54efb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ba8296d2151ca028c549cd5fd8822c6532b43537b59d946bb7b832150b03945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "585d19305b1755a7061b4df2fc8f493a7ee68f8e6106a71eb67905cac12950dd"
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
