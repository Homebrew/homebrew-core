class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.17",
    revision: "0edf8bd9d7aeeb26ff5b2089e50ced058b94f859"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe6c6cbc7b9c91e8f01004e89154e80c3bfb9012d69021a2d90ca21ea967ea39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f09a08c0a7705df46b6c7959b8983a29c8c2669e4eb421e9c4dada0a9df07a82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13d8ee290b98e413bacb9b9caca73e797f1edf549bdf9265578e8a4be2b813dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfec864225f06195900cd7185bcf6806823cc5a765fa2c8e3e8e3c89b3aa2912"
    sha256 cellar: :any_skip_relocation, ventura:        "0b0a722f4883688b9495ad609be0a32680ebe35ec8bc61c06ed8f752458500ee"
    sha256 cellar: :any_skip_relocation, monterey:       "50dd58c4e9f504dce8c3347d3908da0ebdef17db287a1be94a21cf47b83a1e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff5ee0329e76109e07f45db2f9101cf121abb5047be4b7419bcf092eb96630de"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # bundling the frontend assets first will allow them to be embedded into
    # the final build
    system "yarn", "config", "set", "ignore-engines", "true" # allow our newer node
    system "make", "build-js"

    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
