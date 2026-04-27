class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.677.31.tar.gz"
  sha256 "1fe769d62feefa66584048f6e2ae2639a98e169ac52128bcf3e9b80fbb710ab6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fc50c00c021b835eb09d8686bea961aa24f472da8b55064037dc01e5affb2bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4b8be51878fdaf6667402d56e9ce730d260155c4cf6dc9c86bc8fb80162588d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "134bdfb1e16c45d096754941a53d36b67832b5cd1b200837b876f6563d6ea664"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb4064a1482fe5af86f32c077f6bc72c8290f6372b7a5aa25a02f09632fc0ab5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52148c4437248958f709532c0e1e8b6daf0178924a9243bc41d6b9e6986160f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b715410cc8c6d60a01bc03f80174dc0fdeca6bf6b48f778c4616762d2d88574b"
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
