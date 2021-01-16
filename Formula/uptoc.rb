class Uptoc < Formula
  desc "Convenient static file deployment tool that supports multiple platforms"
  homepage "https://github.com/saltbo/uptoc"
  url "https://github.com/saltbo/uptoc.git",
      tag:      "v1.4.3",
      revision: "30266b490379c816fc08ca3670fd96808214b24c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c063e7fc62e3476ed8585a8a23bc34a78e842840425676d5ae752b48f4400fc1" => :big_sur
    sha256 "ded95120d8a855df8ba3cdf8e98ffe082705a720e6c98b0eea95a042bbeb3f15" => :arm64_big_sur
    sha256 "6133ca9ca353edec73753c155c22bfc2757eecf8ae735e178f604fdb6e06a313" => :catalina
    sha256 "01ebd4051546e2834975cd9ca921695a5deed06407ef4009e3b6e0c59dffc5ea" => :mojave
    sha256 "8067fc0ce3bc47e786ad0476c477c34cda3dfdf1a10228aae699ee5afd9f3d10" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
      "-s -w -X main.release=#{version} -X main.commit=#{Utils.git_head} -X main.repo=#{stable.url}",
      *std_go_args,
      "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uptoc -v 2>&1")
    assert_match "uptoc config", shell_output("#{bin}/uptoc ./abc 2>&1", 1)
  end
end
