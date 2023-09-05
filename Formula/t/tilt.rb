class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.5",
    revision: "3a27b6dda979ba3cb94c35004d2dc9834ba6db2a"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "037b5cca0fb914bd36c89ddd26320b4c28909521344468aa086201ebdc22dc15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd399d7af78efd45192f46ab883e04bf80925d2df2ab6b9a4ffdbb6ca7ba50e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc12d82c92efcc9af79bc9e581c8ded24ec1c0fae30bc51b29018422c58dbb70"
    sha256 cellar: :any_skip_relocation, ventura:        "b7898e4196077ce106d5b2447e05cee19c5ee97386b7c47a2dcecb1138d5bab1"
    sha256 cellar: :any_skip_relocation, monterey:       "e065620e0d1c46c65c64f7935e6b2ebac24090ce368728ed483418e72f45a65d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4dc6650a19ba26122c0818aa7a547b99cd4d7ac3861753345fa89a69675cb64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebaf545943c4cddc3df24471eaaa0ae75a375a5a4a857e687d08acd61ef6fb9f"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
