class Yutu < Formula
  desc "Fully functional CLI for YouTube"
  homepage "https://github.com/eat-pray-ai/yutu"
  url "https://github.com/eat-pray-ai/yutu.git",
      tag:      "v0.9.8",
      revision: "9c6e73e0ab60f427587295b9360ce32e09451a4b"
  license "MIT"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  depends_on "go" => :build

  def install
    sha = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp
    date = Utils.safe_popen_read("git", "log", "-1", "--date=format:%Y-%m-%d/%H.%M.%S", "--pretty=%cd").chomp
    mod = "github.com/eat-pray-ai/yutu/cmd"
    os = "#{mod}.Os=#{OS.mac? ? "darwin" : "linux"}"
    arch = "#{mod}.Arch=#{Hardware::CPU.arch}"
    ver = "#{mod}.Version=v#{version}"
    commit = "#{mod}.Commit=#{sha}"
    commit_date = "#{mod}.CommitDate=#{date}"
    ldflags = "-w -s -X #{os} -X #{arch} -X #{ver} -X #{commit} -X #{commit_date}"
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    output = shell_output("#{bin}/yutu version 2>&1")
    assert_match "yutu🐰 version v#{version}", output
  end
end
