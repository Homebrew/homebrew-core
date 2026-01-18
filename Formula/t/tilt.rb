class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.36.0",
      revision: "dd573535e79b343967fc29503a2537df8de340f7"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21a4b4914d8b38ffa6d49a40c085aad2f209659569519682ec608e0cc76e1fa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f761d5778e7ea6dba64b76cdaccbd0333c3affb1fa80fe323a520df15c04e56a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f786299789b0636df3b8a34602b130807f59e794463f8528de172a9d10517220"
    sha256 cellar: :any_skip_relocation, sonoma:        "b623f3fa5552dba5d1b9257e31c79a086bfb10e811405212048c1370c6295bbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "476cae759e5f2dc3ec062d6115f3c4ecf9de9ce885c47b2e7d8246557cab3376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de8f2ff81ee85fb6761fccef7e6d786f1dd49e433ba91478e80c02961196d5b2"
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

    generate_completions_from_executable(bin/"tilt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
