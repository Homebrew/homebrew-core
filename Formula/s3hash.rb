# Classname should match the name of the installed package.
class S3hash < Formula
  desc "Calculate/verify ETag of an S3 object, given a file and chunk size"
  homepage "https://github.com/peakgames/s3hash"

  # Source code archive. Each tagged release will have one
  url "https://github.com/peakgames/s3hash/archive/v0.1.0.tar.gz"
  sha256 "bd627eebb14b244196d4e98282d779a4d76ce6913458850dfbb501200b843b0d"
  head "https://github.com/peakgames/s3hash"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/peakgames/s3hash"
    # Copy all files from their current location (GOPATH root)
    # to $GOPATH/src/github.com/peakgames/s3hash
    bin_path.install Dir["*"]
    cd bin_path do
      # Install the compiled binary into Homebrew's `bin` - a pre-existing
      # global variable
      system "go", "build", "-o", bin/"s3hash", "./cmd/s3hash"
    end
  end

  # Homebrew requires tests.
  test do
    # "2>&1" redirects standard error to stdout.
    assert_match "s3hash", shell_output("#{bin}/s3hash --help 2>&1", 0)
  end
end
