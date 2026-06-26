# ATM-Project

A complete **DevOps demonstration project** showcasing a secure ATM Banking Simulation Gateway with end-to-end CI/CD pipeline, Infrastructure as Code, Containerization, and Kubernetes orchestration.

## Project Overview
This project simulates core ATM operations (Balance Inquiry & Cash Withdrawal) using a lightweight Node.js backend. The main focus is on **DevOps practices** — from code to production-ready deployment on AWS EKS.

## Architecture Diagram

```mermaid
flowchart TD
    subgraph "Developer / Source"
        Git[GitHub Repo]
    end
    
    subgraph "CI Pipeline (Jenkins)"
        Sonar[SonarQube Code Analysis]
        Build[Docker Build]
        Push[DockerHub Push]
    end
    
    subgraph "Infrastructure (Terraform)"
        AWS[AWS VPC + EKS Cluster]
    end
    
    subgraph "CD / Runtime (Kubernetes)"
        Deploy[Deployment + Service]
        Pods[ATM App Pods]
    end
    
    Git --> Sonar --> Build --> Push --> Deploy
    Terraform --> AWS --> Deploy# ATM-Project

