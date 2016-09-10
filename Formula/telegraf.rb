require "language/go"

class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://influxdata.com"

  stable do
    url "https://github.com/influxdata/telegraf.git",
      :tag => "1.0.0",
      :revision => "59ab7931ecd883689933edf215a7004488941856"

    go_resource "github.com/aerospike/aerospike-client-go" do
      url "https://github.com/aerospike/aerospike-client-go.git",
          :revision => "45863b7fd8640dc12f7fdd397104d97e1986f25a"
    end

    go_resource "github.com/nats-io/nats" do
      url "https://github.com/nats-io/nats.git",
          :revision => "b13fc9d12b0b123ebc374e6b808c6228ae4234a3"
    end

    go_resource "github.com/nats-io/nuid" do
      url "https://github.com/nats-io/nuid.git",
          :revision => "4f84f5f3b2786224e336af2e13dba0a0a80b76fa"
    end

    go_resource "github.com/sparrc/aerospike-client-go" do
      url "https://github.com/sparrc/aerospike-client-go.git",
          :revision => "d4bb42d2c2d39dae68e054116f4538af189e05d5"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e13a3fa5766cff827f499ae988dcb5058f826e2485285eb9fd8b7177cec97b27" => :sierra
    sha256 "20264684d9c2ceb39e041a46b75a7e3c1e65318c37f6b28f6e5e94124ed1a73f" => :el_capitan
    sha256 "f70ae29e98f80377f71892d55f1ae32bb30edcc9fada555899bad18f1048c536" => :yosemite
    sha256 "46af416abf7a731cb5cb81469e3c610374f24704977581b77eca9694b2e6c5ca" => :mavericks
  end

  head do
    url "https://github.com/influxdata/telegraf.git"

    go_resource "github.com/aerospike/aerospike-client-go" do
      url "https://github.com/aerospike/aerospike-client-go.git",
          :revision => "7f3a312c3b2a60ac083ec6da296091c52c795c63"
    end

    go_resource "github.com/nats-io/nats" do
      url "https://github.com/nats-io/nats.git",
          :revision => "ea8b4fd12ebb823073c0004b9f09ac8748f4f165"
    end

    go_resource "github.com/nats-io/nuid" do
      url "https://github.com/nats-io/nuid.git",
          :revision => "a5152d67cf63cbfb5d992a395458722a45194715"
    end
  end

  depends_on "go" => :build

  go_resource "github.com/Shopify/sarama" do
    url "https://github.com/Shopify/sarama.git",
        :revision => "8aadb476e66ca998f2f6bb3c993e9a2daa3666b9"
  end

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
        :revision => "219c8cb75c258c552e999735be6df753ffc7afdc"
  end

  go_resource "github.com/amir/raidman" do
    url "https://github.com/amir/raidman.git",
        :revision => "53c1b967405155bfc8758557863bf2e14f814687"
  end

  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
        :revision => "13a12060f716145019378a10e2806c174356b857"
  end

  go_resource "github.com/beorn7/perks" do
    url "https://github.com/beorn7/perks.git",
        :revision => "3ac7bf7a47d159a033b107610db8a1b6575507a4"
  end

  go_resource "github.com/cenkalti/backoff" do
    url "https://github.com/cenkalti/backoff.git",
        :revision => "4dc77674aceaabba2c7e3da25d4c823edfb73f99"
  end

  go_resource "github.com/couchbase/go-couchbase" do
    url "https://github.com/couchbase/go-couchbase.git",
        :revision => "cb664315a324d87d19c879d9cc67fda6be8c2ac1"
  end

  go_resource "github.com/couchbase/gomemcached" do
    url "https://github.com/couchbase/gomemcached.git",
        :revision => "a5ea6356f648fec6ab89add00edd09151455b4b2"
  end

  go_resource "github.com/couchbase/goutils" do
    url "https://github.com/couchbase/goutils.git",
        :revision => "5823a0cbaaa9008406021dc5daf80125ea30bba6"
  end

  go_resource "github.com/dancannon/gorethink" do
    url "https://github.com/dancannon/gorethink.git",
        :revision => "e7cac92ea2bc52638791a021f212145acfedb1fc"
  end

  go_resource "github.com/davecgh/go-spew" do
    url "https://github.com/davecgh/go-spew.git",
        :revision => "5215b55f46b2b919f50a1df0eaa5886afe4e3b3d"
  end

  go_resource "github.com/docker/engine-api" do
    url "https://github.com/docker/engine-api.git",
        :revision => "8924d6900370b4c7e7984be5adc61f50a80d7537"
  end

  go_resource "github.com/docker/go-connections" do
    url "https://github.com/docker/go-connections.git",
        :revision => "f549a9393d05688dff0992ef3efd8bbe6c628aeb"
  end

  go_resource "github.com/docker/go-units" do
    url "https://github.com/docker/go-units.git",
        :revision => "5d2041e26a699eaca682e2ea41c8f891e1060444"
  end

  go_resource "github.com/eapache/go-resiliency" do
    url "https://github.com/eapache/go-resiliency.git",
        :revision => "b86b1ec0dd4209a588dc1285cdd471e73525c0b3"
  end

  go_resource "github.com/eapache/queue" do
    url "https://github.com/eapache/queue.git",
        :revision => "ded5959c0d4e360646dc9e9908cff48666781367"
  end

  go_resource "github.com/eclipse/paho.mqtt.golang" do
    url "https://github.com/eclipse/paho.mqtt.golang.git",
        :revision => "0f7a459f04f13a41b7ed752d47944528d4bf9a86"
  end

  go_resource "github.com/go-sql-driver/mysql" do
    url "https://github.com/go-sql-driver/mysql.git",
        :revision => "1fca743146605a172a266e1654e01e5cd5669bee"
  end

  go_resource "github.com/gobwas/glob" do
    url "https://github.com/gobwas/glob.git",
        :revision => "49571a1557cd20e6a2410adc6421f85b66c730b5"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
        :revision => "552c7b9542c194800fd493123b3798ef0a832032"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git",
        :revision => "427fb6fc07997f43afa32f35e850833760e489a7"
  end

  go_resource "github.com/gonuts/go-shellquote" do
    url "https://github.com/gonuts/go-shellquote.git",
        :revision => "e842a11b24c6abfb3dd27af69a17f482e4b483c2"
  end

  go_resource "github.com/gorilla/context" do
    url "https://github.com/gorilla/context.git",
        :revision => "1ea25387ff6f684839d82767c1733ff4d4d15d0a"
  end

  go_resource "github.com/gorilla/mux" do
    url "https://github.com/gorilla/mux.git",
        :revision => "c9e326e2bdec29039a3761c07bece13133863e1e"
  end

  go_resource "github.com/hailocab/go-hostpool" do
    url "https://github.com/hailocab/go-hostpool.git",
        :revision => "e80d13ce29ede4452c43dea11e79b9bc8a15b478"
  end

  go_resource "github.com/hashicorp/consul" do
    url "https://github.com/hashicorp/consul.git",
        :revision => "5aa90455ce78d4d41578bafc86305e6e6b28d7d2"
  end

  go_resource "github.com/hpcloud/tail" do
    url "https://github.com/hpcloud/tail.git",
        :revision => "b2940955ab8b26e19d43a43c4da0475dd81bdb56"
  end

  go_resource "github.com/influxdata/config" do
    url "https://github.com/influxdata/config.git",
        :revision => "b79f6829346b8d6e78ba73544b1e1038f1f1c9da"
  end

  go_resource "github.com/influxdata/influxdb" do
    url "https://github.com/influxdata/influxdb.git",
        :revision => "e094138084855d444195b252314dfee9eae34cab"
  end

  go_resource "github.com/influxdata/toml" do
    url "https://github.com/influxdata/toml.git",
        :revision => "af4df43894b16e3fd2b788d01bd27ad0776ef2d0"
  end

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
        :revision => "29ae4ffbc9a6fe9fb2bc5029050ce6996ea1d3bc"
  end

  go_resource "github.com/kardianos/service" do
    url "https://github.com/kardianos/service.git",
        :revision => "5e335590050d6d00f3aa270217d288dda1c94d0a"
  end

  go_resource "github.com/klauspost/crc32" do
    url "https://github.com/klauspost/crc32.git",
        :revision => "19b0b332c9e4516a6370a0456e6182c3b5036720"
  end

  go_resource "github.com/lib/pq" do
    url "https://github.com/lib/pq.git",
        :revision => "e182dc4027e2ded4b19396d638610f2653295f36"
  end

  go_resource "github.com/matttproud/golang_protobuf_extensions" do
    url "https://github.com/matttproud/golang_protobuf_extensions.git",
        :revision => "d0c3fe89de86839aecf2e0579c40ba3bb336a453"
  end

  go_resource "github.com/miekg/dns" do
    url "https://github.com/miekg/dns.git",
        :revision => "cce6c130cdb92c752850880fd285bea1d64439dd"
  end

  go_resource "github.com/mreiferson/go-snappystream" do
    url "https://github.com/mreiferson/go-snappystream.git",
        :revision => "028eae7ab5c4c9e2d1cb4c4ca1e53259bbe7e504"
  end

  go_resource "github.com/naoina/go-stringutil" do
    url "https://github.com/naoina/go-stringutil.git",
        :revision => "6b638e95a32d0c1131db0e7fe83775cbea4a0d0b"
  end

  go_resource "github.com/nsqio/go-nsq" do
    url "https://github.com/nsqio/go-nsq.git",
        :revision => "0b80d6f05e15ca1930e0c5e1d540ed627e299980"
  end

  go_resource "github.com/opencontainers/runc" do
    url "https://github.com/opencontainers/runc.git",
        :revision => "89ab7f2ccc1e45ddf6485eaa802c35dcf321dfc8"
  end

  go_resource "github.com/prometheus/client_golang" do
    url "https://github.com/prometheus/client_golang.git",
        :revision => "18acf9993a863f4c4b40612e19cdd243e7c86831"
  end

  go_resource "github.com/prometheus/client_model" do
    url "https://github.com/prometheus/client_model.git",
        :revision => "fa8ad6fec33561be4280a8f0514318c79d7f6cb6"
  end

  go_resource "github.com/prometheus/common" do
    url "https://github.com/prometheus/common.git",
        :revision => "e8eabff8812b05acf522b45fdcd725a785188e37"
  end

  go_resource "github.com/prometheus/procfs" do
    url "https://github.com/prometheus/procfs.git",
        :revision => "406e5b7bfd8201a36e2bb5f7bdae0b03380c2ce8"
  end

  go_resource "github.com/samuel/go-zookeeper" do
    url "https://github.com/samuel/go-zookeeper.git",
        :revision => "218e9c81c0dd8b3b18172b2bbfad92cc7d6db55f"
  end

  go_resource "github.com/shirou/gopsutil" do
    url "https://github.com/shirou/gopsutil.git",
        :revision => "4d0c402af66c78735c5ccf820dc2ca7de5e4ff08"
  end

  go_resource "github.com/soniah/gosnmp" do
    url "https://github.com/soniah/gosnmp.git",
        :revision => "eb32571c2410868d85849ad67d1e51d01273eb84"
  end

  go_resource "github.com/streadway/amqp" do
    url "https://github.com/streadway/amqp.git",
        :revision => "b4f3ceab0337f013208d31348b578d83c0064744"
  end

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
        :revision => "1f4a1643a57e798696635ea4c126e9127adb7d3c"
  end

  go_resource "github.com/vjeantet/grok" do
    url "https://github.com/vjeantet/grok.git",
        :revision => "83bfdfdfd1a8146795b28e547a8e3c8b28a466c2"
  end

  go_resource "github.com/wvanbergen/kafka" do
    url "https://github.com/wvanbergen/kafka.git",
        :revision => "46f9a1cf3f670edec492029fadded9c2d9e18866"
  end

  go_resource "github.com/wvanbergen/kazoo-go" do
    url "https://github.com/wvanbergen/kazoo-go.git",
        :revision => "0f768712ae6f76454f987c3356177e138df258f8"
  end

  go_resource "github.com/yuin/gopher-lua" do
    url "https://github.com/yuin/gopher-lua.git",
        :revision => "bf3808abd44b1e55143a2d7f08571aaa80db1808"
  end

  go_resource "github.com/zensqlmonitor/go-mssqldb" do
    url "https://github.com/zensqlmonitor/go-mssqldb.git",
        :revision => "ffe5510c6fa5e15e6d983210ab501c815b56b363"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "5dc8cb4b8a8eb076cbb5a06bc3b8682c15bdbbd3"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "6acef71eb69611914f7a30939ea9f6e194c78172"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "a71fd10341b064c10f4a81ceac72bcf70f26ea34"
  end

  go_resource "gopkg.in/dancannon/gorethink.v1" do
    url "https://gopkg.in/dancannon/gorethink.v1.git",
        :revision => "7d1af5be49cb5ecc7b177bf387d232050299d6ef"
  end

  go_resource "gopkg.in/fatih/pool.v2" do
    url "https://gopkg.in/fatih/pool.v2.git",
        :revision => "cba550ebf9bce999a02e963296d4bc7a486cb715"
  end

  go_resource "gopkg.in/mgo.v2" do
    url "https://gopkg.in/mgo.v2.git",
        :revision => "d90005c5262a3463800497ea5a89aed5fe22c886"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "a83829b6f1293c91addabc89d0571c246397bbf4"
  end

  def install
    ENV["GOPATH"] = buildpath
    telegraf_path = buildpath/"src/github.com/influxdata/telegraf"
    telegraf_path.install Dir["*"]
    revision = `git rev-parse HEAD`.strip
    version = `git describe --tags`.strip

    Language::Go.stage_deps resources, buildpath/"src"

    cd telegraf_path do
      system "go", "install",
             "-ldflags", "-X main.version=#{version} -X main.commit=#{revision}",
             "./..."
    end

    bin.install "bin/telegraf"
    etc.install telegraf_path/"etc/telegraf.conf" => "telegraf.conf"
  end

  def post_install
    # Create directory for additional user configurations
    (etc/"telegraf.d").mkpath
  end

  plist_options :manual => "telegraf -config #{HOMEBREW_PREFIX}/etc/telegraf.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/telegraf</string>
          <string>-config</string>
          <string>#{etc}/telegraf.conf</string>
          <string>-config-directory</string>
          <string>#{etc}/telegraf.d</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/telegraf.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/telegraf.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system "telegraf", "-config", testpath/"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end
