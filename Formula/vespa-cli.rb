class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.64.13.tar.gz"
  sha256 "383381181aa74708f7e59d627d094c89581466d8134defb39afbef37c01f80c0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8584735fd3c4af40d14174f9237d767a2d38cd92d7b5d0c61f8effb52a81fd26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "184d01d7d2179ab9a1f5c890cebff2b30e45627a83ffef35fa132d4a7aa999db"
    sha256 cellar: :any_skip_relocation, monterey:       "ff26e4c3f4770f0abc03f64b73e3fa5e700a0b2114c36e50363e870e3bb687d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c994c09eb36bc630f82b5d321136e22abf6343907d06b654a6a9c28a10004f2f"
    sha256 cellar: :any_skip_relocation, catalina:       "266d8bc7b3a01561476b7903a84c8e937051c67edcc43dd79d0ba3efab81f5e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d65db8164a7cad4c936824e5f060636b366dc37f2a524635365c794c31acb8e"
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
