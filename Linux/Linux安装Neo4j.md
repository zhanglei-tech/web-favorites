# Linux安装Neo4j

# Ubuntu

```bash
curl -fsSL https://debian.neo4j.com/neotechnology.gpg.key |sudo gpg --dearmor -o /usr/share/keyrings/neo4j.gpg
```

```bash
echo "deb [signed-by=/usr/share/keyrings/neo4j.gpg] https://debian.neo4j.com stable 4.1" | sudo tee -a /etc/apt/sources.list.d/neo4j.list
```

```bash
sudo apt update
sudo apt install neo4j
```

```bash
sudo systemctl enable neo4j
```

```bash
sudo systemctl start neo4j
```

# CentOS 7

```bash
rpm --import https://debian.neo4j.com/neotechnology.gpg.key
```

```bash
cat <<EOF>  /etc/yum.repos.d/neo4j.repo
[neo4j]
name=Neo4j RPM Repository
baseurl=https://yum.neo4j.com/stable
enabled=1
gpgcheck=1
EOF
```

```bash
yum install neo4j
```

```bash
systemctl enable neo4j
```

```bash
systemctl start neo4j
```