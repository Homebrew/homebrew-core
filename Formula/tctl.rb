class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.5.1.tar.gz"
  sha256 "a2f75873d7c211e07c40653c605e64fcf732543c9d50683b2d61a985f6b3f37f"
  license "MIT"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/temporal.io/tctl_staging"
    # Copy all files from their current location (GOPATH root) to the binpath
    bin_path.install Dir["*"]
    cd bin_path do
      # Install the compiled binary into Homebrew's `bin`
      system "go", "build", "-o", bin/"tctl", "cmd/tools/cli/main.go"
    end
  end

  test do
    # Given tctl is pointless without a server, not much intersting to test here.
    run_output = shell_output("#{bin}/tctl --version 2>&1")
    assert_match "tctl version", run_output
  end
end
