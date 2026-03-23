class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.37.0",
      revision: "3b46fa9b81adbeb078239a99d71fb170d0afbc19"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef146e2f979d75f61e910f9b76856b681d0d87d78a80bf044a8492e7a85ad96e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9ac705ad17e10524bd64e9066e695a4c54d83ef49d52e8e46147a5da51d24d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6cc0a759a05aec252ed3a83796df835c7102bc66ea30ce1260e870889b96992"
    sha256 cellar: :any_skip_relocation, sonoma:        "c93acf8f6661b9be137a1a53c45a269087bff398e922d9c2df9dd31d96868fe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9aab03206d8e7ab80b6ce88f4ea19eb10d695927eaa33510cc76c38dc143366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6e8dd9ec0fec8f5dba50cb4a3102558ae939bd572f4275d6896175f981bb4ea"
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
