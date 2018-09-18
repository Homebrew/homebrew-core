class Riak < Formula
  desc "Distributed database"
  homepage "http://basho.com/products/riak-kv/"
  url "https://github.com/basho/riak.git",
      :tag => "riak-2.2.3",
      :revision => "d96b67eeb5f934c673ee8e5c75c00a3861f388aa"

  bottle do
    sha256 "163efe4af2492bd3885aebeafb894c2ec5f6c3cbc08cdfaf78de07deaf645336" => :high_sierra
    sha256 "07304227841afc17ee201ccaed0fc8607f55c05c2f7920d5785cfda3c0979cf1" => :sierra
    sha256 "98169ac6af3d395dac47522d17759ac165af24158dbc403ccc88603921f6528c" => :el_capitan
    sha256 "803da1ba13fca2ff1c5ed1d341c064218a03697d8114e40c325553a430920653" => :yosemite
  end

  depends_on :arch => :x86_64
  depends_on "erlang@17"
  depends_on :macos => :mountain_lion

  # rebar tries to fetch fuse using git over ssh
  resource "fuse" do
    url "https://github.com/jlouis/fuse.git",
        :revision => "21c6e52ced3af294f2fe636039106068da12eeeb"
  end

  resource "hyper" do
    url "https://github.com/basho/hyper.git",
        :revision => "f6ed834cd8799623ec00faaedc9ef2a55876d5d8"

    # Avoid build failure "type gb_tree/0 is deprecated and will be removed in OTP
    # 18.0; use use gb_trees:tree/0 or preferably gb_trees:tree/2"
    # Upstream PR from 4 Oct 2016 "namespaced types for erlang 17+"
    patch do
      url "https://github.com/basho/hyper/pull/6.patch?full_index=1"
      sha256 "e70b9b281a8b75387b7213be8df066b89f3fdfa37f7a4786df1b572024072591"
    end
  end

  resource "solr" do
    url "https://files-source.tiot.jp/riak/solr/solr-4.10.4-yz-2.tgz",
        :using => :nounzip
    mirror "https://dl.bintray.com/homebrew/mirror/riak-solr-4.10.4-yz-2.tgz"
    version "4.10.4-yz-2"
    sha256 "4aa81ef3c67c30263b90e6dfe3a68f005e034cf7344e91eb43c2d8462dd5c53b"
  end

  resource "yokozuna" do
    url "https://github.com/basho/yokozuna.git",
        :revision => "b53d999529626301c36fa3efa22b2b0165217556"
  end

  def install
    ENV.deparallelize

    ["fuse", "hyper", "yokozuna"].each do |r|
      (buildpath/"deps/#{r}").install resource(r)
    end

    buildpath.install resource("solr")

    # So that rebar uses the solr resource rather than trying to redownload it
    inreplace "deps/yokozuna/tools/grab-solr.sh",
              "TMP_FILE=$TMP_DIR/$FILENAME",
              "TMP_FILE=#{buildpath}/$FILENAME"

    system "git", "-C", "deps/hyper", "commit", "-am", "hyper-patch"
    hyper_revision = Utils.popen_read("git", "-C", "deps/hyper", "rev-parse",
                                      "HEAD").chomp

    system "git", "-C", "deps/yokozuna", "commit", "-am", "solr-location"
    yokozuna_revision = Utils.popen_read("git", "-C", "deps/yokozuna",
                                         "rev-parse", "HEAD").chomp

    # So that rebar doesn't revert the modifications
    inreplace "rebar.config.lock" do |s|
      s.gsub! resource("hyper").specs[:revision], hyper_revision
      s.gsub! resource("yokozuna").specs[:revision], yokozuna_revision
    end

    # So that rebar doesn't try to refetch the dependencies modified above
    inreplace "Makefile", "git checkout $(REPO_TAG) &&",
                          "git checkout $(REPO_TAG) && mv ../../deps . &&"

    system "make", "package" # don't use "make rel" as it breaks `riak version`

    logdir = var/"log/riak"
    datadir = var/"lib/riak"
    libexec.install Dir["distdir/osxbuild/riak-2.2.3/*"]
    logdir.mkpath
    datadir.mkpath
    (datadir/"ring").mkpath
    inreplace "#{libexec}/lib/env.sh" do |s|
      s.change_make_var! "RUNNER_BASE_DIR", libexec
      s.change_make_var! "RUNNER_LOG_DIR", logdir
    end
    inreplace "#{libexec}/etc/riak.conf" do |c|
      c.gsub! /(platform_data_dir *=).*$/, "\\1 #{datadir}"
      c.gsub! /(platform_log_dir *=).*$/, "\\1 #{logdir}"
    end
    bin.write_exec_script libexec/"bin/riak"
    bin.write_exec_script libexec/"bin/riak-admin"
    bin.write_exec_script libexec/"bin/riak-debug"
    bin.write_exec_script libexec/"bin/search-cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/riak version")
  end
end
