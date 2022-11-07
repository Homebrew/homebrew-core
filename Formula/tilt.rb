class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.30.11",
    revision: "af2080d0cebc45217d43f248a22da40752c9fc18"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5496c2f402442622cb52fc4b01ac5d02dbaecbb8180b99303b51e8588a9e7c71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5570fcb597b9ef05d35ca6b39262ae0b884ba0d261ecdae087c51e2223417efd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3a6adf2d233d3bb1778d7083c52834cc44a331b0e136486e18fa4849d9220e5"
    sha256 cellar: :any_skip_relocation, monterey:       "e0a33b044e4f0e61295b97ba157334346943558d62103a6e9338ce6b2fc7f2f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "347137798a69931525799e262b2fc5713bf51af0711076e73e33c3bd55c6878a"
    sha256 cellar: :any_skip_relocation, catalina:       "49ec7582b048ee5eeb4062998458021ec444c122f6e446dca3eaa8f93c53137c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9f096d8e5a759d5db13b3d5b063fd53fcdaef8ac4f9c7ee40112b7da83fbef1"
  end

  depends_on "go" => :build
  depends_on "node@16" => :build
  depends_on "yarn" => :build

  def install
    # bundling the frontend assets first will allow them to be embedded into
    # the final build
    system "make", "build-js"

    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
