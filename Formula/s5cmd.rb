# Classname should match the name of the installed package.
class S5cmd < Formula
  desc "Parallel S3 and local filesystem execution tool"
  homepage "https://github.com/peakgames/s5cmd"

  # Source code archive. Each tagged release will have one
  url "https://github.com/peakgames/s5cmd/archive/v0.5.7.tar.gz"
  sha256 "99095c440ba4a1aeb5e1451d2fc8f396dcc401489e9f59cfbad6477bfec419e9"
  head "https://github.com/peakgames/s5cmd"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/peakgames/s5cmd"
    # Copy all files from their current location (GOPATH root)
    # to $GOPATH/src/github.com/peakgames/s3hash
    bin_path.install Dir["*"]
    cd bin_path do
      # Install the compiled binary into Homebrew's `bin` - a pre-existing
      # global variable
      system "go", "build", "-o", bin/"s5cmd"
    end

    ohai "To install shell completion, run s5cmd -cmp-install"
  end

  # Homebrew requires tests.
  test do
    # "2>&1" redirects standard error to stdout.
    assert_match "s5cmd version v0.5.7", shell_output("#{bin}/s5cmd -version 2>&1", 0)
  end
end
