class Uptoc < Formula
  desc "Convenient static file deployment tool that supports multiple platforms"
  homepage "https://github.com/saltbo/uptoc"
  url "https://github.com/saltbo/uptoc.git",
      :tag      => "v1.4.3",
      :revision => "30266b490379c816fc08ca3670fd96808214b24c"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.release=#{version} -X main.commit=#{stable.specs[:revision]} -X main.repo=#{stable.url}",
             *std_go_args,
             "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uptoc -v 2>&1")
    assert_match "uptoc config", shell_output("#{bin}/uptoc ./abc 2>&1", 1)
  end
end
