class SyncGateway < Formula
  desc "Make Couchbase Server a replication endpoint for Couchbase Lite"
  homepage "http://docs.couchbase.com/sync-gateway"
  url "https://github.com/couchbase/sync_gateway.git",
      :tag => "1.2.1",
      :revision => "26c202a800226ce599cbaf9b2fcc4576a924d45e"

  head "https://github.com/couchbase/sync_gateway.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec6f97bbc7d3afeef7bc7274d93a2a89e4d51fd04eb64882295537aa46f407c6" => :sierra
    sha256 "d2885b854b63c1acf88918a29122bbd26383f80001e9f5f6cace389d189df24e" => :el_capitan
    sha256 "ee84b69ab0eeedc05fce8b24879414c539d31418aba1ad32a4e59bf8ccd73e9d" => :yosemite
    sha256 "a49e6035c48b7117c3b3f672cc50b928878f9c0b04a6529d02dabd0397c5c0ff" => :mavericks
  end

  depends_on "go" => :build

  def install
    system "make", "buildit"
    bin.install "bin/sync_gateway"
  end

  test do
    pid = fork { exec "#{bin}/sync_gateway" }
    sleep 1
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
