---
- hosts: ec2_instances
  become: true
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes

    - name: Install Docker dependencies
      apt:
        name:
          - docker.io
          - python3-pip
        state: present

    - name: Install Docker Compose
      pip:
        name: docker-compose
        state: present
        executable: pip3

    - name: Clone Node.js app repository
      git:
        repo: https://github.com/APSARA-2023/Dev-Repo.git
        dest: /var/www/html/dev-app-demo

    - name: Build Docker image
      command: docker build -t dev-app /var/www/html/dev-app-demo

    - name: Run Docker container
      command: docker run -d -p 3000:3000 --name dev-app-container dev-app
