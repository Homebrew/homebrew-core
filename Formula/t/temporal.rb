class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "0d7cdc8b9abc09f21b58c275e21733715e7e7d4e8033f5cedaa02fd4b125e26d"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c95cae700d85e3a20ef3b59420c08a647cc943ead3f8eeb2df0329edc611632"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "464c35f0cae1422792151e46375d0efd40862ddf51844ff94c184e1b59fd26ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19a4455765c7c4caf5bb6fa2ffbbfdbd2181d6eafa665b7e4ff1f4390bb17a53"
    sha256 cellar: :any_skip_relocation, sonoma:        "b274d8bf3feefa55b814ea39318ed3cffa64ffd9bcd61412ed5e1fb55e5b256e"
    sha256 cellar: :any_skip_relocation, ventura:       "6709e8866eb20c9f0f4ef2976facc479c1f76f2bef68f3e8439edb5430dfe274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec4bddfc9bfdd737426e105890078785ffdafa2acb3a9248e1cf9dca98516711"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/temporalio/cli/temporalcli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/temporal"
    generate_completions_from_executable bin/"temporal", "completion"
  end

  service do
    run [opt_bin/"temporal", "server", "start-dev"]
    keep_alive true
    error_log_path var/"log/temporal.log"
    log_path var/"log/temporal.log"
    working_dir var
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end
