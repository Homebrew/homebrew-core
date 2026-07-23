class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.37.5",
      revision: "08268a960e87e544768ec8ed4db7c9c21862cb63"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f81c5eb56ad50b84098cf489b94f6f229118658d3d9656f1521c1ee505380a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca7280c1b3f4175b2a1954dfcd00e3494a0f99fc537e731be8ea626f1f7c7902"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e6eef2dfeb7c410a0295cf4b57155389c60d0d3b67becdbd80cb4e7b4e92047"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8f3c51eb4a837ec57d976e7f5765a527e9cfdd8d2e1af4740271fd516bdf752"
    sha256 cellar: :any,                 arm64_linux:   "6d3decf8ef93f56579888141dd05a9ba9a56170b5f422fd0ca6c91d720906fec"
    sha256 cellar: :any,                 x86_64_linux:  "f3e5ba16c7e060fa5af2cd7479a46aeea5caa0594a5ec9cbefb1a3cadfb9be0e"
  end

  depends_on "corepack" => :build # for newer yarn
  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    # bundling the frontend assets first will allow them to be embedded into
    # the final build
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
